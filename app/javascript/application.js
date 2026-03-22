// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
    const totalsDetails = document.querySelector(".tablet-totals");

    if (!totalsDetails) return;

    totalsDetails.addEventListener("toggle", () => {
        if (!totalsDetails.open) return;

        const table = totalsDetails.querySelector("table");
        const summary = totalsDetails.querySelector("summary");

        if (table && summary) {
            requestAnimationFrame(() => {
                const tableTop =
                    summary.getBoundingClientRect().top +
                    window.scrollY +
                    summary.offsetHeight +
                    8;

                window.scrollTo({
                    top: tableTop,
                    behavior: "smooth"
                });
            });
        }
    });
});

document.addEventListener("turbo:load", () => {
    document.querySelectorAll(".notification .delete").forEach((deleteButton) => {
        const notification = deleteButton.parentNode

        deleteButton.addEventListener("click", () => {
            notification.remove()
        })
    })
})

function initCategorySelect() {
    const select = document.querySelector("#category-select");

    if (!select) return;

    if (select.tomselect) {
        select.tomselect.destroy();
    }

    new TomSelect(select, {
        create: false,
        sortField: {
            field: "text",
            direction: "asc"
        }
    });
}

document.addEventListener("turbo:load", initCategorySelect);
document.addEventListener("turbo:render", initCategorySelect);
