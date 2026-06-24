const introScreen = document.getElementById("intro-screen");

if (introScreen) {
  document.body.classList.add("intro-active");

  setTimeout(() => {
    introScreen.classList.add("hide");

    setTimeout(() => {
      introScreen.style.display = "none";
      document.body.classList.remove("intro-active");
      document.body.classList.add("home-visible");
    }, 900);

  }, 2600);
}