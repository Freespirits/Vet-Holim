(function () {
    "use strict";

    function getStorage() {
        try {
            if (typeof window !== "undefined" && window.localStorage) {
                return window.localStorage;
            }
        } catch (e) {
            return null;
        }
        return null;
    }

    const storage = getStorage();

    document.addEventListener("DOMContentLoaded", function () {
        setupTabs();
        setupGridInteractions();
        setupHeaderInputsPersistence();
        setupFlutterEmbed();
    });

    function setupTabs() {
        const tabButtons = Array.from(document.querySelectorAll("[data-tab-target]"));
        const panels = Array.from(document.querySelectorAll(".tab-panel"));

        function activate(targetId) {
            panels.forEach((panel) => {
                panel.classList.toggle("active", panel.id === targetId);
            });
            tabButtons.forEach((btn) => {
                btn.classList.toggle("active", btn.dataset.tabTarget === targetId);
            });
        }

        tabButtons.forEach((btn) => {
            btn.addEventListener("click", function () {
                activate(btn.dataset.tabTarget);
            });
        });

        const initial = tabButtons.find((btn) => btn.classList.contains("active"))?.dataset.tabTarget || tabButtons[0]?.dataset.tabTarget;
        if (initial) {
            activate(initial);
        }
    }

    function setupGridInteractions() {
        const hourCells = Array.from(document.querySelectorAll("thead .hour-cell"));
        const hours = hourCells.map((c) => c.textContent.trim());
        const bodyRows = Array.from(document.querySelectorAll("tbody tr"));

        bodyRows.forEach((row, rowIndex) => {
            const labelTh = row.querySelector(".row-label, .row-label-rtl");
            if (!labelTh) {
                return;
            }

            const labelText = labelTh.textContent.trim() || "שורה " + (rowIndex + 1);
            const timeCells = Array.from(row.querySelectorAll(".time-cell"));

            timeCells.forEach((cell, colIndex) => {
                const hour = hours[colIndex] || "";
                const key = "cell-" + rowIndex + "-" + colIndex;

                if (!cell.title && hour) {
                    cell.title = labelText + " @ " + hour;
                }

                if (storage) {
                    const saved = storage.getItem(key);
                    if (saved === "1") {
                        cell.classList.add("cell-marked");
                    }
                }

                cell.addEventListener("click", function () {
                    const nowMarked = !cell.classList.contains("cell-marked");
                    cell.classList.toggle("cell-marked", nowMarked);

                    if (storage) {
                        storage.setItem(key, nowMarked ? "1" : "0");
                    }
                });
            });
        });
    }

    function setupHeaderInputsPersistence() {
        const inputs = Array.from(document.querySelectorAll(".field-input"));

        inputs.forEach((input, index) => {
            const key = input.dataset.key || "field-" + index;

            if (storage) {
                const savedValue = storage.getItem(key);
                if (savedValue !== null) {
                    input.value = savedValue;
                }
            }

            input.addEventListener("input", function () {
                if (!storage) {
                    return;
                }
                storage.setItem(key, input.value);
            });
        });
    }

    function setupFlutterEmbed() {
        const frame = document.querySelector("#flutter-app-frame");
        const status = document.querySelector("[data-flutter-status]");

        if (!frame) {
            return;
        }

        const source = frame.dataset.src || frame.getAttribute("src") || "client/web/index.html";
        if (!frame.getAttribute("src")) {
            frame.src = source;
        }

        updateStatusElement(status, "טוען רכיב Flutter…", "loading");
        frame.addEventListener("load", function () {
            updateStatusElement(status, "רכיב Flutter נטען בהצלחה.", "ready");
        });
        frame.addEventListener("error", function () {
            updateStatusElement(status, "שגיאת טעינה – ודאו שהבנייה זמינה ב-client/web.", "error");
        });
    }

    function updateStatusElement(target, message, tone) {
        if (!target) {
            return;
        }
        target.textContent = message;
        target.dataset.tone = tone;
    }
})();
