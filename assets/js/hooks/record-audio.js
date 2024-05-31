/** @type { import("./hook").Hook } */
export const recordAudio = {
  mounted() {
    const element = this.el;
    if (!(element instanceof HTMLElement)) return;

    /** @type {MediaRecorder | undefined} */
    let recorder;

    element.addEventListener("click", () => {
      if (recorder?.state === "recording") {
        recorder.requestData();
        return;
      }

      const { uploadName, maxDuration } = getRecordConfig(element);
      navigator.mediaDevices
        .getUserMedia({ audio: true, video: false })
        .then(stream => {
          recorder = new MediaRecorder(stream);
          recorder.start();
          this.pushEventTo(element, "recording");

          const timeout = setTimeout(() => {
            if (!recorder) return;
            recorder.requestData();
          }, maxDuration * 1000);

          recorder.addEventListener(
            "dataavailable",
            e => {
              clearTimeout(timeout);
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

/**
 *
 * @param {HTMLElement} element
 */
function getRecordConfig(element) {
  const { uploadName, maxDuration } = element.dataset;
  if (!uploadName) {
    throw new Error("Please set data-upload-name on the element with the proper upload name");
  }
  if (!maxDuration) {
    throw new Error(
      "Please set data-max-duration on the element with the proper max recording duration in seconds"
    );
  }

  return { uploadName, maxDuration: +maxDuration };
}
