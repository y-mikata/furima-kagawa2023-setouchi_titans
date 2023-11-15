document.addEventListener("DOMContentLoaded", () => {
  const thumbnails = document.querySelectorAll(".thumbnail-image img");

  thumbnails.forEach((img) => {
    img.addEventListener("click", (e) => {
      const newSrc = e.target.src;
      if (newSrc) {
        document.getElementById("main-img").src = newSrc;
        thumbnails.forEach((thumb) => thumb.classList.remove("active-thumbnail"));
        e.target.classList.add("active-thumbnail");
      }
    });
  });
});
