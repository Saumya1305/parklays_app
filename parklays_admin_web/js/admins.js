async function loadAdmins() {
    const admins = await api("/admins", "GET", null, true);

    document.getElementById("adminsList").innerHTML =
        admins.map(a => `
            <div class="card">
                <h4>${a.name}</h4>
                <p>${a.phoneNumber}</p>

                <button onclick="editAdmin(${a.id}, '${a.name}', '${a.phoneNumber}')">Edit</button>
                <button onclick="deleteAdmin(${a.id})" style="background:#c0392b">Delete</button>
            </div>
        `).join("");
}

async function createAdmin() {
    await api("/admins", "POST", {
        name: document.getElementById("adminName").value,
        phoneNumber: document.getElementById("adminPhone").value
    }, true);

    loadAdmins();
}

function editAdmin(id, name, phone) {
    document.getElementById("adminName").value = name;
    document.getElementById("adminPhone").value = phone;

    document.querySelector("button[onclick='createAdmin()']").outerHTML =
        `<button onclick="updateAdmin(${id})">Update Admin</button>`;
}

async function updateAdmin(id) {
    await api(`/admins/${id}`, "PUT", {
        id,
        name: document.getElementById("adminName").value,
        phoneNumber: document.getElementById("adminPhone").value
    }, true);

    window.location.reload();
}

async function deleteAdmin(id) {
    await api(`/admins/${id}`, "DELETE", null, true);
    loadAdmins();
}

loadAdmins();
