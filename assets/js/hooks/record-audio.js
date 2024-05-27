/** @type { import("./hook").Hook } */
export const recordAudio = {
  mounted() {
    const element = this.el;
    if (!(element instanceof HTMLElement)) return;

    /** @type {MediaRecorder | undefined} */
    let recorder;

    element.addEventListener("click", () => {
      if (recorder && recorder.state === "recording") {
        recorder.requestData();
        return;
      }

      navigator.mediaDevices
        .getUserMedia({ audio: true, video: false })
        .then(stream => {
          recorder = new MediaRecorder(stream);
          recorder.start();

          recorder.addEventListener(
            "dataavailable",
            e => {
              this.upload("audio", [e.data]);

              element.form?.requestSubmit();

              stream.getTracks().forEach(t => t.stop());
            },
            { once: true }
          );
        })
        .catch(console.error);
    });
  },
};
