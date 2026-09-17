const USE_VIDEO_INTRO = false;

const introScreen = document.getElementById("intro-screen");
const videoScreen = document.getElementById("video-screen");
const introVideo = document.getElementById("intro-video");
const skipVideo = document.getElementById("skip-video");

if (introScreen) {

  document.body.classList.add("intro-active");

  /* ========================================
     1. INTRO AA
     ======================================== */

  setTimeout(() => {

    introScreen.classList.add("hide");

    setTimeout(() => {

      introScreen.style.display = "none";


      /* ========================================
         OPCIÓN A:
         VIDEO ENTRE INTRO E INDEX
         ======================================== */

      if (USE_VIDEO_INTRO && videoScreen && introVideo) {

        document.body.classList.remove("intro-active");
        document.body.classList.add("home-visible");

        videoScreen.classList.add("show");

        introVideo.currentTime = 0;

        introVideo.play().catch(() => {
          finishVideoIntro();
        });

      }


      /* ========================================
         OPCIÓN B:
         IR DIRECTAMENTE AL INDEX
         ======================================== */

      else {

        document.body.classList.remove("intro-active");
        document.body.classList.add("home-visible");

      }

    }, 900);

  }, 1200);


  /* ========================================
     TERMINAR VIDEO INTERMEDIO
     ======================================== */

  function finishVideoIntro() {

    if (!videoScreen || !introVideo) return;

    videoScreen.classList.remove("show");
    videoScreen.classList.add("hide");

    introVideo.pause();

    setTimeout(() => {

      videoScreen.style.display = "none";

      document.body.classList.remove("intro-active");
      document.body.classList.add("home-visible");

    }, 900);
  }


  if (introVideo) {
    introVideo.addEventListener("ended", finishVideoIntro);
  }


  if (skipVideo) {
    skipVideo.addEventListener("click", finishVideoIntro);
  }

}