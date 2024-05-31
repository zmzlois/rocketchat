type HookContext = {
  /** Attribute referencing the bound DOM node. */
  el: Node;
  /** The reference to the underlying `LiveSocket` instance. */
  liveSocket: import("phoenix_live_view").LiveSocket;
  /** Method to push an event from the client to the LiveView server. */
  pushEvent(event, payload, replyHandler: (reply, ref) => void): void;
  /** Method to push targeted events from the client to LiveViews and LiveComponents.
   *
   * It sends the event to the LiveComponent or LiveView the `selectorOrTarget` is defined in, where its value can be either a query selector or an actual DOM element.
   *
   * If the query selector returns more than one element it will send the event to all of them, even if all the elements are in the same LiveComponent or LiveView. */
  pushEventTo(selectorOrTarget: string | Element, event, payload, replyHandler: (reply, ref) => void): void;
  /** Method to handle an event pushed from the server. */
  handleEvent(event, callback: (paylod) => void): void;
  /** Method to inject a list of file-like objects into an uploader. */
  upload(name: string, files: Blob[]): void;
  /** Method to inject a list of file-like objects into an uploader. The hook will send the files to the uploader with name defined by `Phoenix.LiveView.allow_upload/3` on the server-side.
   *
   * Dispatching new uploads triggers an input change event which will be sent to the LiveComponent or LiveView the `selectorOrTarget` is defined in, where its value can be either a query selector or an actual DOM element.
   *
   * If the query selector returns more than one live file input, an error will be logged. */
  uploadTo(selectorOrTarget: string | Element, name: string, files: Blob[]): void;
};

export type Hook = {
  /** The element has been added to the DOM and its server LiveView has finished mounting */
  mounted?(this: HookContext): void;
  /** The element is about to be updated in the DOM. Note: any call here must be synchronous as the operation cannot be deferred or cancelled
   *
   * **Only called when inside LiveView context** */
  beforeUpdate?(this: HookContext): void;
  /** The element has been updated in the DOM by the server
   *
   * **Only called when inside LiveView context**
   */
  updated?(this: HookContext): void;
  /** The element has been removed from the page, either by a parent update, or by the parent being removed entirely
   *
   * **Only called when inside LiveView context**
   */
  destroyed?(this: HookContext): void;
  /** The element's parent LiveView has disconnected from the server
   *
   * **Only called when inside LiveView context**
   */
  disconnected?(this: HookContext): void;
  /** The element's parent LiveView has reconnected to the server
   *
   * **Only called when inside LiveView context**
   */
  reconnected?(this: HookContext): void;
};
