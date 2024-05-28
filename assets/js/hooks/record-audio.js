/** @type { import("./hook").Hook } */
export const recordAudio = {
  mounted() {
    const element = this.el;
    if (!(element instanceof HTMLElement)) return;
    const { uploadName } = element.dataset;
    if (!uploadName) {
      throw new Error("Please set data-upload-name on the elemen with the proper upload name");
    }

    /** @type {MediaRecorder | undefined} */
    let recorder;

    element.addEventListener("click", () => {
      if (recorder?.state === "recording") {
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
              this.upload(uploadName, [e.data]);

              // yes, I hate this too
              setTimeout(() => {
                element.form?.requestSubmit();
              }, 150);

              stream.getTracks().forEach(t => t.stop());
              recorder = undefined;
            },
            { once: true }
          );
        })
        .catch(console.error);
    });
  },
};
