const lotId = localStorage.getItem("lotId");

async function loadSlots() {
    const slots = await api(`/parkinglots/${lotId}/slots`, "GET", null, true);

    document.getElementById("slotList").innerHTML =
        slots.map(s => `
            <div class="slot-card">
                <h4>Slot #${s.slotNumber}</h4>
                <p>${s.isFree ? "Free" : "Occupied"}</p>
            </div>
        `).join("");
}

loadSlots();

