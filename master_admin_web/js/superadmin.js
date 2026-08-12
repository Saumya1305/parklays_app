// ===================== API URLs ==========================
const QUERIES_API = "http://localhost:5049/api/masteradmin/queries";
const SUPERADMIN_API = "http://localhost:5049/api/masteradmin/superadmins";

let currentlyOpenQuery = null;

// ==========================================================
//                    LOAD SUPER ADMINS
// ==========================================================
async function loadSuperAdmins() {
    try {
        const res = await fetch(SUPERADMIN_API);
        const data = await res.json();

        const table = document.getElementById("superAdminTable");
        table.innerHTML = "";

        data.forEach(admin => {
            table.innerHTML += `
                <tr>
                    <td>${admin.id}</td>
                    <td>${admin.name}</td>
                    <td>${admin.email}</td>
                    <td>${admin.phone}</td>
                    <td>${admin.organization ?? "-"}</td>
                    <td>${admin.createdAt?.split("T")[0] ?? "-"}</td>
                </tr>`;
        });
    } catch (err) {
        console.error(err);
        alert("Failed to load SuperAdmins");
    }
}

// ==========================================================
//             ADD SUPER ADMIN FORM SUBMISSION
// ==========================================================
document.getElementById("addSuperAdminForm").addEventListener("submit", async e => {
    e.preventDefault();

    const payload = {
        name: document.getElementById("name").value.trim(),
        email: document.getElementById("email").value.trim(),
        phone: document.getElementById("phone").value.trim(),
        password: document.getElementById("password").value,
        organization: document.getElementById("organization").value.trim()
    };

    try {
        const res = await fetch(SUPERADMIN_API, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        if (!res.ok) throw new Error(`Server returned ${res.status}`);

        document.getElementById("successBox").innerText = "SuperAdmin added successfully!";
        document.getElementById("successBox").style.display = "block";
        document.getElementById("errorBox").style.display = "none";

        e.target.reset();
        loadSuperAdmins();

    } catch (err) {
        console.error(err);
        document.getElementById("errorBox").innerText = "Failed to add SuperAdmin";
        document.getElementById("errorBox").style.display = "block";
        document.getElementById("successBox").style.display = "none";
    }
});

// ==========================================================
//                    LOAD QUERIES
// ==========================================================
async function loadQueries() {
    try {
        const res = await fetch(QUERIES_API);
        if (!res.ok) throw new Error(`Server returned ${res.status}`);

        const data = await res.json();
        const table = document.getElementById("queryTable");
        table.innerHTML = "";

        data.forEach(q => {
            const firstMessage = q.messages?.[0]?.messageText || "-";
            const shortMsg = firstMessage.substring(0, 30) + "...";

            const dateOnly = q.createdAt ? q.createdAt.split("T")[0] : "-";

            table.innerHTML += `
                <tr>
                    <td>${q.id}</td>
                    <td>${q.title}</td>
                    <td>-</td>
                    <td>${shortMsg}</td>
                    <td>${q.status}</td>
                    <td>${dateOnly}</td>
                    <td><button class="btn-reply" onclick="openQuery(${q.id})">Open</button></td>
                </tr>
            `;
        });

    } catch (err) {
        console.error(err);
        alert("Failed to load queries.");
    }
}

// ==========================================================
//                    OPEN QUERY MODAL
// ==========================================================
async function openQuery(id) {
    if (currentlyOpenQuery === id) return;
    currentlyOpenQuery = id;

    try {
        const res = await fetch(`${QUERIES_API}/${id}`);
        const q = await res.json();

        document.getElementById("modalTitle").innerText =
            `Query #${q.id} — ${q.title || ''}`;

        const messagesDiv = document.getElementById("modalMessages");
        messagesDiv.innerHTML = "";

        (q.messages || []).forEach(m => {
            const box = document.createElement("div");
            box.className = "message-box";

            box.innerHTML = `
                <small>${m.senderType} — ${new Date(m.createdAt).toLocaleString()}</small>
                <p>${m.messageText}</p>`;

            messagesDiv.appendChild(box);
        });

        document.getElementById("statusSelect").value = q.status ?? "Pending";
        document.getElementById("replyText").value = "";

        document.getElementById("queryModal").style.display = "block";
        document.getElementById("queryModalOverlay").style.display = "block";

        document.getElementById("sendReplyBtn").onclick = () => sendReply(q.id);

    } catch (err) {
        console.error(err);
        alert("Failed to load query details.");
    }
}

// ==========================================================
//                  SEND REPLY TO QUERY
// ==========================================================
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

    try {
        const res = await fetch(`${QUERIES_API}/reply`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        if (!res.ok) throw new Error(`Server returned ${res.status}`);

        closeModal();
        loadQueries();

    } catch (err) {
        console.error(err);
        alert("Failed to send reply.");
    }
}

// ==========================================================
//                  CLOSE MODAL
// ==========================================================
function closeModal() {
    currentlyOpenQuery = null;
    document.getElementById("queryModal").style.display = "none";
    document.getElementById("queryModalOverlay").style.display = "none";
}

document.getElementById("closeModal").onclick = closeModal;
document.getElementById("queryModalOverlay").onclick = closeModal;

// ==========================================================
//                    PAGE LOAD
// ==========================================================
window.onload = () => {
    loadSuperAdmins();
    loadQueries();

    const superBtn = document.getElementById("superAdminBtn");
    const queriesBtn = document.getElementById("queriesBtn");
    const superSection = document.getElementById("superAdminSection");
    const queriesSection = document.getElementById("queriesSection");

    superBtn.addEventListener("click", () => {
        superSection.style.display = "block";
        queriesSection.style.display = "none";
    });

    queriesBtn.addEventListener("click", () => {
        superSection.style.display = "none";
        queriesSection.style.display = "block";
    });
};