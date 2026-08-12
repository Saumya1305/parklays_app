document.addEventListener("DOMContentLoaded", () => {
    loadAdmins();
});

async function loadAdmins() {
    const superAdminId = localStorage.getItem("superadmin_id");
    if (!superAdminId) {
        alert("Not logged in!");
        return;
    }

    const adminTableBody = document.getElementById("admin-table-body");
    const totalCount = document.getElementById("totalCount");
    adminTableBody.innerHTML = `<tr><td colspan="10">Loading admins ...</td></tr>`;
    totalCount.textContent = "Total Admins: -";

    try {
        const res = await fetch(`http://localhost:5049/api/superadmin/${superAdminId}/admins`);
        if (!res.ok) throw new Error("Fetch failed");

        const data = await res.json();
        // adjust if nested
        const admins = Array.isArray(data) ? data : data.admins;

        totalCount.textContent = `Total Admins: ${admins.length}`;

        if (admins.length === 0) {
            adminTableBody.innerHTML = `<tr><td colspan="10">No admins found</td></tr>`;
            return;
        }

        adminTableBody.innerHTML = "";
        admins.forEach((admin, index) => {
            adminTableBody.innerHTML += `
                <tr>
                    <td>${index + 1}</td>
                    <td>${admin.name || "-"}</td>
                    <td>${admin.dob ? new Date(admin.dob).toLocaleDateString('en-GB') : "-"}</td>
                    <td>${admin.email || "-"}</td>
                    <td>${admin.phone || "-"}</td>
                    <td>${admin.lotId || "-"}</td>
                    <td>${admin.mallName || "-"}</td>
                    <td>${admin.isActive ? "Yes" : "No"}</td>
                    <td>${admin.createdBy || "-"}</td>
                    <td>${admin.createdAt ? new Date(admin.createdAt).toLocaleDateString('en-GB') : "-"}</td>
                </tr>
            `;
        });

    } catch (err) {
        console.error(err);
        adminTableBody.innerHTML = `<tr><td colspan="10">Error loading admins</td></tr>`;
    }
}