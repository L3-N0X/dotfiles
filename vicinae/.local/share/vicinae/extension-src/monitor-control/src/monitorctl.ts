import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

/**
 * All the real work lives in this script, so the layout file stays the single
 * source of truth whether it is driven from here or from a shell.
 */
export const MONITORCTL = join(homedir(), ".config", "hypr", "scripts", "monitorctl");

export type Monitor = {
  name: string;
  description: string;
  key: string;
  anchor: boolean;
  side: "left" | "right" | "up" | "down" | "anchor";
  zoom: number;
  transform: number;
  resolution: string;
  position: string;
  focused: boolean;
};

export type Layout = {
  anchor: string;
  monitors: Monitor[];
};

export async function run(args: string[]): Promise<string> {
  try {
    const { stdout } = await execFileAsync(MONITORCTL, args);
    return stdout.trim();
  } catch (error) {
    // monitorctl reports every expected failure on stderr as a single line,
    // which reads far better in a toast than execFile's wrapper message.
    const stderr = (error as { stderr?: string }).stderr?.trim();
    throw new Error(stderr || (error as Error).message);
  }
}

export async function loadLayout(): Promise<Layout> {
  return JSON.parse(await run(["list", "--json"])) as Layout;
}

export const ZOOM_PRESETS = [1, 1.25, 1.5, 1.75, 2];

export function describeZoom(zoom: number): string {
  return `${Number(zoom.toFixed(3))}x`;
}
