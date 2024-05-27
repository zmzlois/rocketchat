/** @type { import("./hook").Hook } */
export const mouseMove = {
  mounted() {
    const element = this.el;
    const throttle = parseInt(element.dataset.moveThrottle);
    const parsedThrottle = Number.isNaN(throttle) ? 0 : throttle;
    let lastMove = 0;
    element.addEventListener("pointermove", e => {
      const now = performance.now();
      const elapsed = now - lastMove;
      if (elapsed < parsedThrottle) return;

      lastMove = now;

      const x = e.offsetX;
      const y = e.offsetY;
      this.pushEvent("mouse-move", { x, y });
    });
  },
};
