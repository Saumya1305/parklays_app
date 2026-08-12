// ========================================================================
// GLOBAL ELEMENTS
// ========================================================================

const superAdminBtn = document.getElementById("superAdminBtn");
const queriesBtn = document.getElementById("queriesBtn");

const superAdminSection = document.getElementById("superAdminSection");
const queriesSection = document.getElementById("queriesSection");

const superAdminsTableBody = document.getElementById("superAdminsTableBody");
const addSuperAdminForm = document.getElementById("addSuperAdminForm");

const queriesTableBody = document.getElementById("queriesTableBody");

// 🔥 GLOBAL VARIABLE — Required for Reply API
let currentQueryId = null;

// ========================================================================
// SIDEBAR NAVIGATION
// ========================================================================

superAdminBtn.addEventListener("click", () => {
    superAdminSection.style.display = "block";
    queriesSection.style.display = "none";
    superAdminBtn.classList.add("active");
    queriesBtn.classList.remove("active");
});

queriesBtn.addEventListener("click", () => {
    superAdminSection.style.display = "none";
    queriesSection.style.display = "block";
    queriesBtn.classList.add("active");
    superAdminBtn.classList.remove("active");
    loadQueries();
});

// ========================================================================
// SUPER ADMINS MANAGEMENT
// ========================================================================

let superAdmins = [];

// Load Super Admins
async function loadSuperAdmins() {
    try {
        const res = await fetch("http://localhost:5049/api/masteradmin/superadmins");
        superAdmins = await res.json();
        renderSuperAdminsTable();
    } catch (err) {
        console.error(err);
        alert("Failed to load SuperAdmins from server");
    }
}

// Add Super Admin
addSuperAdminForm.addEventListener("submit", async (e) => {
    e.preventDefault();

    const formData = new FormData(addSuperAdminForm);
    const payload = {
        name: formData.get("name"),
        email: formData.get("email"),
        phone: formData.get("phone") || "",
        password: formData.get("password") || "newpass123",
        organization: formData.get("organization") || ""
    };

    try {
        const res = await fetch("http://localhost:5049/api/masteradmin/superadmins", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        const data = await res.json();

        if (res.ok) {
            superAdmins.push(data);
            renderSuperAdminsTable();
            addSuperAdminForm.reset();
            alert("SuperAdmin added successfully!");
        } else {
            alert("Error: " + data);
        }
    } catch (err) {
        console.error(err);
        alert("Server error. Check console.");
    }
});

// Render table
function renderSuperAdminsTable() {
    superAdminsTableBody.innerHTML = "";

    superAdmins.forEach(admin => {
        const isActive = admin.status !== "Inactive";

        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${admin.id}</td>
            <td>${admin.name}</td>
            <td>${admin.email}</td>
            <td>${admin.phone || "-"}</td>
            <td>${admin.organization || "-"}</td>
            <td>${new Date(admin.createdAt).toLocaleDateString()}</td>
            <td style="font-weight:600; color:${isActive ? "green" : "red"};">
                ${isActive ? "Active" : "Inactive"}
            </td>
            <td>
                <button 
                    class="btn-status-toggle"
                    onclick="toggleSuperAdminStatus(${admin.id})"
                    style="
                        background:${isActive ? '#ff4d4d' : '#4CAF50'};
                        color:white;
                        padding:6px 12px;
                        border:none;
                        border-radius:4px;
                        cursor:pointer;
                    ">
                    ${isActive ? "Deactivate" : "Activate"}
                </button>
            </td>
        `;

        superAdminsTableBody.appendChild(row);
    });
}

function toggleSuperAdminStatus(id) {
    const admin = superAdmins.find(a => a.id === id);
    if (!admin) return;

    admin.status = admin.status === "Inactive" ? "Active" : "Inactive";
    renderSuperAdminsTable();
}

// ========================================================================
// QUERIES MANAGEMENT
// ========================================================================

let queries = [];

// Load all queries
async function loadQueries() {
    try {
        const res = await fetch("http://localhost:5049/api/masteradmin/queries");
        if (!res.ok) throw new Error("API error");

        const data = await res.json();
        queries = data;

        queriesTableBody.innerHTML = "";

        data.forEach(q => {
            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${q.id}</td>
                <td>${q.userName || "-"}</td>
                <td>${q.email || "-"}</td>
                <td>${q.message || "-"}</td>
                <td>${q.status || "Pending"}</td>
                <td>${new Date(q.createdAt).toLocaleString()}</td>

                <td>
                    <button class="btn-reply" onclick="openQueryModal(${q.id})">
                        Reply
                    </button>
                </td>
            `;

            queriesTableBody.appendChild(row);
        });

    } catch (err) {
        console.error(err);
        alert("Failed to load queries");
    }
}

// ========================================================================
// QUERY MODAL + MESSAGE THREAD
// ========================================================================

async function openQueryModal(queryId) {
    try {
        const res = await fetch(`http://localhost:5049/api/masteradmin/queries/${queryId}`);
        if (!res.ok) {
            alert("Failed to load query details");
            return;
        }

        const q = await res.json();

        document.getElementById("queryModal").style.display = "block";
        document.getElementById("queryModalOverlay").style.display = "block";

        document.getElementById("modalTitle").textContent =
            `Query #${q.id} — ${q.title}`;

        const messagesDiv = document.getElementById("modalMessages");
        messagesDiv.innerHTML = "";

        (q.messages || []).forEach(m => {
            const mEl = document.createElement("div");
            mEl.className = "message-box";
            mEl.innerHTML = `
                <small>${m.senderType} @ ${new Date(m.createdAt).toLocaleString()}</small>
                <p>${m.messageText}</p>
            `;
            messagesDiv.appendChild(mEl);
        });

        document.getElementById("statusSelect").value = q.status;
        currentQueryId = queryId;  // 🔥 SAVE ID

        document.getElementById("sendReplyBtn").onclick = sendReply;

    } catch (err) {
        console.error(err);
        alert("Error loading query details");
    }
}

document.getElementById("closeModal").addEventListener("click", closeModal);
document.getElementById("queryModalOverlay").addEventListener("click", closeModal);

function closeModal() {
    document.getElementById("queryModal").style.display = "none";
    document.getElementById("queryModalOverlay").style.display = "none";
    document.getElementById("replyText").value = "";
}

// ========================================================================
// SEND REPLY — FINAL WORKING
// ========================================================================

async function sendReply() {
    const replyText = document.getElementById("replyText").value.trim();
    const newStatus = document.getElementById("statusSelect").value;

    if (!currentQueryId) {
        alert("Invalid query ID");
        return;
    }

    if (!replyText) {
        alert("Reply text cannot be empty");
        return;
    }

    const payload = {
        queryId: currentQueryId,
        senderType: "MasterAdmin",
        senderId: 1,
        messageText: replyText,
        newStatus: newStatus   // 🔥 matches backend model
    };

    try {
        const res = await fetch(
            `http://localhost:5049/api/masteradmin/queries/reply`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            }
        );

        if (!res.ok) throw new Error("Failed");

        alert("Reply sent successfully!");
        closeModal();
        loadQueries();

    } catch (error) {
        console.error(error);
        alert("Failed to send reply");
    }
}

// ========================================================================
// INIT
// ========================================================================

loadSuperAdmins();
loadQueries();