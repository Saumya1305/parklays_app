async function loginSuperAdmin() {
    const phone = document.getElementById("phone").value.trim();
    const password = document.getElementById("password").value.trim();
    const errorMsg = document.getElementById("errorMsg");

    errorMsg.style.display = "none";

    if (!phone || !password) {
        errorMsg.innerText = "Please fill all fields";
        errorMsg.style.display = "block";
        return;
    }

    try {
        const response = await fetch("http://localhost:5049/api/superadmin/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ phone: phone, password: password })
        });

        const data = await response.json();

        if (!response.ok) {
            errorMsg.innerText = data.message || "Invalid phone or password";
            errorMsg.style.display = "block";
            return;
        }

        // ✔ Backend returns direct object, so save this way
        localStorage.setItem("superAdminId", data.id);
        localStorage.setItem("superAdminName", data.name);
        localStorage.setItem("superAdminPhone", data.phone);

        // Redirect to dashboard
        window.location.href = "dashboard.html";

    } catch (error) {
        console.error(error);
        errorMsg.innerText = "Server error. Check backend.";
        errorMsg.style.display = "block";
    }
}