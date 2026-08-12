async function login() {
    const phone = document.getElementById("phone").value.trim();
    const password = document.getElementById("password").value.trim();

    if (!phone || !password) {
        document.getElementById("msg").innerText = "Please enter phone and password";
        return;
    }

    const response = await api("/superadmin/login", "POST", {
        phoneNumber: phone,
        password: password
    });

    // Backend returns { "token": "...", "superAdmin": { ... } }
    if (response.token) {
        localStorage.setItem("token", response.token);
        localStorage.setItem("superAdmin", JSON.stringify(response.superAdmin));
        window.location.href = "dashboard.html";
    } else {
        document.getElementById("msg").innerText = response.message || "Invalid credentials";
    }
}