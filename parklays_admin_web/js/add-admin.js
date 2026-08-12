const API_ADD_ADMIN = "http://localhost:5049/api/admin/create";

// Auto-fill created_by and created_at in IST
window.onload = () => {
    const superAdminId = localStorage.getItem("superAdminId");
    document.getElementById("created_by").value = superAdminId;

    const now = new Date();
    const ist = new Date(now.toLocaleString("en-US", { timeZone: "Asia/Kolkata" }));

    // FIX: .NET requires ISO datetime --> YYYY-MM-DDTHH:mm:ss
    const formatted =
        ist.getFullYear() + "-" +
        String(ist.getMonth() + 1).padStart(2, "0") + "-" +
        String(ist.getDate()).padStart(2, "0") + "T" +
        String(ist.getHours()).padStart(2, "0") + ":" +
        String(ist.getMinutes()).padStart(2, "0") + ":00";

    document.getElementById("created_at").value = formatted;
};

document.getElementById("adminForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    const body = {
        name: document.getElementById("name").value,
        dob: document.getElementById("dob").value,  // OK
        email: document.getElementById("email").value,
        phone: document.getElementById("phone").value,
        lotId: parseInt(document.getElementById("lotid").value),
        isActive: document.getElementById("is_active").value === "true",
        createdBy: parseInt(localStorage.getItem("superAdminId")),
        createdAt: document.getElementById("created_at").value
    };

    const msg = document.getElementById("msg");

    try {
        const res = await fetch(API_ADD_ADMIN, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(body)
        });

        if (res.ok) {
            msg.style.color = "green";
            msg.textContent = "Admin added successfully!";
        } else {
            msg.style.color = "red";
            msg.textContent = "Failed to add admin!";
        }

    } catch (err) {
        msg.style.color = "red";
        msg.textContent = "Server not reachable!";
    }
});

function logout() {
    localStorage.clear();
    window.location.href = "index.html";
}
