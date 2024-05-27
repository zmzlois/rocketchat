import { recordAudio } from "./audio-recorder";
import { mouseMove } from "./mouse-move";

export const hooks = {
  "mouse-move": mouseMove,
  "record-audio": recordAudio,
};
