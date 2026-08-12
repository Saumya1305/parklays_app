// Set admin name
document.getElementById("adminName").textContent =
    localStorage.getItem("superAdminName") || "Admin";

document.addEventListener("DOMContentLoaded", () => {
    // 🔥 Queries Raised Button
    document.getElementById("queriesRaisedBtn").addEventListener("click", async () => {
        const superAdminId = localStorage.getItem("superadmin_id") || 1;
        try {
            const res = await fetch(`http://localhost:5049/api/masteradmin/queries/superadmin/${superAdminId}`);
            if (!res.ok) throw new Error("Failed to load queries");

            const data = await res.json();
            const container = document.getElementById("queriesList");
            container.innerHTML = "";

            if (!data || data.length === 0) {
                container.innerHTML = "<p>No queries found.</p>";
                document.getElementById("queriesRaisedModal").style.display = "block";
                return;
            }

            data.forEach(function(q) {
                const qDiv = document.createElement("div");
                qDiv.style.border = "1px solid #ccc";
                qDiv.style.borderRadius = "8px";
                qDiv.style.padding = "8px";
                qDiv.style.marginBottom = "10px";
                qDiv.style.background = "#f9f9f9";

                var messagesHTML = "";
                (q.messages || []).forEach(function(m) {
                    if (!m) return;
                    messagesHTML += '<div style="margin:5px 0; padding:5px; background:' + 
                        (m.senderType === 'SuperAdmin' ? '#D7EE46' : '#e0f7fa') + 
                        '; border-radius:4px;">' +
                        '<strong>' + m.senderType + ':</strong> ' + m.messageText + '<br>' +
                        '<small>' + new Date(m.createdAt).toLocaleString() + '</small>' +
                        '</div>';
                });

                qDiv.innerHTML = '<strong>Query #' + q.id + ':</strong> ' + q.title +
                                 '<br><small>Status: ' + q.status + '</small>' +
                                 '<div style="margin-top:5px;">' + messagesHTML + '</div>';

                container.appendChild(qDiv);
            });

            // Show modal
            document.getElementById("queriesRaisedModal").style.display = "block";

        } catch (err) {
            console.error(err);
            alert("Failed to load queries raised.");
        }
    });

    // Close Queries Modal
    document.getElementById("closeQueriesModal").addEventListener("click", function() {
        document.getElementById("queriesRaisedModal").style.display = "none";
    });

    // Help / Report Issue Modal
    document.getElementById("helpBtn").addEventListener("click", function() {
        document.getElementById("helpModal").style.display = "block";
    });
    document.getElementById("closeHelpModal").addEventListener("click", function() {
        document.getElementById("helpModal").style.display = "none";
    });

    // Click outside modal to close (combined for both modals)
    window.onclick = function(event) {
        const queriesModal = document.getElementById("queriesRaisedModal");
        const helpModal = document.getElementById("helpModal");
        if (event.target === queriesModal) queriesModal.style.display = "none";
        if (event.target === helpModal) helpModal.style.display = "none";
    };

    // Submit Help / Report Issue
    document.getElementById("submitHelpBtn").addEventListener("click", async function() {
        var title = document.getElementById("helpTitle").value.trim();
        var message = document.getElementById("helpDescription").value.trim();
        var superAdminId = localStorage.getItem("superadmin_id");

        if (!title || !message) {
            alert("Fill all fields");
            return;
        }

        try {
            await fetch("http://localhost:5049/api/queries/create", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({
                    title: title,
                    messageText: message,
                    superAdminId: Number(superAdminId)
                })
            });
            alert("Help request sent!");
            document.getElementById("helpModal").style.display = "none";
            document.getElementById("helpTitle").value = "";
            document.getElementById("helpDescription").value = "";
        } catch (err) {
            console.error(err);
            alert("Failed to send help request.");
        }
    });
});

// Logout function
function logout() {
    localStorage.clear();
    window.location.href = "index.html";
}