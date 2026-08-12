async function loadLots() {
    const lots = await api("/parkinglots", "GET", null, true);

    document.getElementById("lotList").innerHTML =
        lots.map(l => `
            <div class="card">
                <h4>${l.name}</h4>
                <p>${l.location}</p>
                <p>Capacity: ${l.capacity}</p>

                <button onclick="openSlots(${l.id})">Slots</button>
                <button onclick="editLot(${l.id}, '${l.name}', '${l.location}', ${l.capacity})">Edit</button>
                <button onclick="deleteLot(${l.id})" style="background:#c0392b">Delete</button>
            </div>
        `).join("");
}

async function createLot() {
    const name = document.getElementById("lotName").value;
    const location = document.getElementById("lotLocation").value;
    const capacity = document.getElementById("lotCapacity").value;

    await api("/parkinglots", "POST", {
        name,
        location,
        capacity: Number(capacity)
    }, true);

    loadLots();
}

function editLot(id, name, location, capacity) {
    document.getElementById("lotName").value = name;
    document.getElementById("lotLocation").value = location;
    document.getElementById("lotCapacity").value = capacity;

    window.scrollTo(0,0);

    document.querySelector("button[onclick='createLot()']").outerHTML =
        `<button onclick="updateLot(${id})">Update Lot</button>`;
}

async function updateLot(id) {
    await api(`/parkinglots/${id}`, "PUT", {
        id,
        name: document.getElementById("lotName").value,
        location: document.getElementById("lotLocation").value,
        capacity: Number(document.getElementById("lotCapacity").value)
    }, true);

    window.location.reload();
}

async function deleteLot(id) {
    await api(`/parkinglots/${id}`, "DELETE", null, true);
    loadLots();
}

function openSlots(id) {
    localStorage.setItem("lotId", id);
    window.location.href = "slots.html";
}

loadLots();