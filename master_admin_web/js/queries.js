const QUERIES_API = "http://localhost:5049/api/masteradmin/queries";

let currentlyOpenQuery = null;

// Load all queries
async function loadQueries() {
    try {
        const res = await fetch(QUERIES_API);
        const data = await res.json();

        const table = document.getElementById("queriesTableBody");
        table.innerHTML = "";

        data.forEach(q => {
            const firstMessage = q.messages?.length > 0 ? q.messages[0].messageText : "-";
            const userEmail = q.messages?.length > 0 ? q.messages[0].senderEmail ?? "-" : "-";
            const userName = q.messages?.length > 0 ? q.messages[0].senderName ?? "-" : "-";

            table.innerHTML += `
                <tr>
                    <td>${q.id}</td>
                    <td>${userName}</td>
                    <td>${userEmail}</td>
                    <td>${firstMessage}</td>
                    <td>${q.status}</td>
                    <td>${new Date(q.createdAt).toLocaleString()}</td>
                    <td><button class="btn btn-reply" onclick="openQuery(${q.id})">Open</button></td>
                </tr>
            `;
        });

    } catch (err) {
        console.error("LOAD QUERIES ERROR:", err);
        alert("Failed to load queries");
    }
}

// Open a specific query
async function openQuery(id) {
    if (currentlyOpenQuery === id) return;
    currentlyOpenQuery = id;

    const res = await fetch(`${QUERIES_API}/${id}`);
    const q = await res.json();

    document.getElementById("modalTitle").innerHTML =
        `Query #${q.id} — ${q.title}`;

    const messagesDiv = document.getElementById("modalMessages");
    messagesDiv.innerHTML = "";

    (q.messages || []).forEach(m => {
        const box = document.createElement("div");
        box.className = "message-box";
        box.innerHTML = `
            <small>${m.senderType} — ${new Date(m.createdAt).toLocaleString()}</small>
            <p>${m.messageText}</p>
        `;
        messagesDiv.appendChild(box);
    });

    document.getElementById("statusSelect").value = q.status;
    document.getElementById("replyText").value = "";

    document.getElementById("queryModal").style.display = "block";
    document.getElementById("queryModalOverlay").style.display = "block";

    document.getElementById("sendReplyBtn").onclick = () => sendReply(q.id);
}

// Send Reply
async function sendReply(queryId) {
    const text = document.getElementById("replyText").value.trim();
    const newStatus = document.getElementById("statusSelect").value;

    if (!text) return alert("Please type a reply.");

    const payload = {
        queryId,
        senderType: "MasterAdmin",
        senderId: 1,
        messageText: text,
        newStatus
    };

    const res = await fetch(`http://localhost:5049/api/queries/reply`, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(payload)
    });

    if (!res.ok) {
        alert("Failed to send reply");
        return;
    }

    closeModal();
    loadQueries();
}

function closeModal() {
    currentlyOpenQuery = null;
    document.getElementById("queryModal").style.display = "none";
    document.getElementById("queryModalOverlay").style.display = "none";
}

document.getElementById("closeModal").onclick = closeModal;
document.getElementById("queryModalOverlay").onclick = closeModal;

loadQueries();