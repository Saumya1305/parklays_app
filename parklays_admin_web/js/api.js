const BASE_URL = "http://localhost:5049/api";

async function api(endpoint, method = "GET", body = null, auth = false) {
    const options = {
        method,
        headers: { "Content-Type": "application/json" }
    };

    if (auth) {
        options.headers["Authorization"] = "Bearer " + localStorage.getItem("token");
    }

    if (body) {
        options.body = JSON.stringify(body);
    }

    const res = await fetch(BASE_URL + endpoint, options);
    return res.json();
}