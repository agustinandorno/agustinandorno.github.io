const introScreen = document.getElementById("intro-screen");
const videoScreen = document.getElementById("video-screen");
const introVideo = document.getElementById("intro-video");
const skipVideo = document.getElementById("skip-video");

if (introScreen && videoScreen && introVideo && skipVideo) {

  document.body.classList.add("intro-active");

  let videoFinished = false;

  /* 1. INTRO ACTUAL: logo + footer */

  setTimeout(() => {

    introScreen.classList.add("hide");

    setTimeout(() => {
introScreen.style.display = "none";

/* Mostrar el index detrás del video */
document.body.classList.remove("intro-active");
document.body.classList.add("home-visible");

/* 2. MOSTRAR VIDEO */

videoScreen.classList.add("show");

      introVideo.currentTime = 0;

      introVideo.play().catch(() => {
        finishVideoIntro();
      });

    }, 900);

  }, 1200);


  /* 3. TERMINAR VIDEO Y MOSTRAR INDEX */

  function finishVideoIntro() {

    if (videoFinished) return;
    videoFinished = true;

    videoScreen.classList.remove("show");
    videoScreen.classList.add("hide");

    introVideo.pause();

    setTimeout(() => {

      videoScreen.style.display = "none";

      document.body.classList.remove("intro-active");
      document.body.classList.add("home-visible");

    }, 900);
  }


  /* El video termina normalmente */

  introVideo.addEventListener("ended", finishVideoIntro);


  /* El usuario pulsa SKIP */

  skipVideo.addEventListener("click", finishVideoIntro);

}