import { Toast, showHUD, showToast } from "@vicinae/api";
import { run } from "./monitorctl";

/**
 * The one-keystroke case: exactly one external display is plugged in and it is
 * on the wrong side. monitorctl picks it on its own when given no target.
 */
export default async function Command() {
  try {
    await showHUD(await run(["swap"]));
  } catch (e) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Could not swap sides",
      message: (e as Error).message,
    });
  }
}
