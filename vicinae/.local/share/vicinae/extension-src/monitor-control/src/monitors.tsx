import { Action, ActionPanel, Color, Icon, List, Toast, showToast } from "@vicinae/api";
import { useCallback, useEffect, useState } from "react";
import {
  Layout,
  Monitor,
  ZOOM_PRESETS,
  describeZoom,
  loadLayout,
  run,
} from "./monitorctl";

const SIDE_ICON: Record<string, Icon> = {
  left: Icon.ArrowLeft,
  right: Icon.ArrowRight,
  up: Icon.ArrowUp,
  down: Icon.ArrowDown,
  anchor: Icon.Anchor,
};

const ROTATIONS: { title: string; value: string }[] = [
  { title: "Normal", value: "normal" },
  { title: "90°", value: "90" },
  { title: "180°", value: "180" },
  { title: "270°", value: "270" },
];

export default function Command() {
  const [layout, setLayout] = useState<Layout | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const refresh = useCallback(async () => {
    try {
      setLayout(await loadLayout());
      setError(null);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  /**
   * Run a monitorctl subcommand and reflect the result. monitorctl already
   * prints a human sentence describing what it did, so use that as the toast.
   */
  const act = useCallback(
    async (args: string[], pending: string) => {
      const toast = await showToast({ style: Toast.Style.Animated, title: pending });
      try {
        const message = await run(args);
        toast.style = Toast.Style.Success;
        toast.title = message || "Layout updated";
        await refresh();
      } catch (e) {
        toast.style = Toast.Style.Failure;
        toast.title = "Could not change the layout";
        toast.message = (e as Error).message;
      }
    },
    [refresh],
  );

  if (error) {
    return (
      <List>
        <List.EmptyView
          icon={Icon.Monitor}
          title="Could not read the monitor layout"
          description={error}
        />
      </List>
    );
  }

  return (
    <List isLoading={isLoading} searchBarPlaceholder="Monitors...">
      <List.Section title={layout ? `Anchored on ${layout.anchor}` : "Monitors"}>
        {(layout?.monitors ?? []).map((monitor) => (
          <MonitorItem key={monitor.key} monitor={monitor} act={act} refresh={refresh} />
        ))}
      </List.Section>
    </List>
  );
}

function MonitorItem({
  monitor,
  act,
  refresh,
}: {
  monitor: Monitor;
  act: (args: string[], pending: string) => Promise<void>;
  refresh: () => Promise<void>;
}) {
  const target = monitor.name;
  const rotated = monitor.transform !== 0;

  return (
    <List.Item
      icon={SIDE_ICON[monitor.side] ?? Icon.Monitor}
      title={monitor.description || monitor.name}
      subtitle={monitor.name}
      accessories={[
        monitor.anchor
          ? { tag: { value: "anchor", color: Color.Purple } }
          : { tag: { value: monitor.side, color: Color.Blue } },
        { tag: { value: describeZoom(monitor.zoom), color: Color.Green } },
        ...(rotated ? [{ tag: { value: `${monitor.transform * 90}°`, color: Color.Orange } }] : []),
        { text: monitor.resolution },
      ]}
      actions={
        <ActionPanel>
          <ActionPanel.Section title="Position">
            {!monitor.anchor && (
              <Action
                title="Move to the Other Side"
                icon={Icon.Repeat}
                onAction={() => act(["swap", target], `Moving ${monitor.name}`)}
              />
            )}
            <Action
              title="Move Left"
              icon={Icon.ArrowLeft}
              onAction={() => act(["side", target, "left"], `Moving ${monitor.name} left`)}
            />
            <Action
              title="Move Right"
              icon={Icon.ArrowRight}
              onAction={() => act(["side", target, "right"], `Moving ${monitor.name} right`)}
            />
            <Action
              title="Move Above"
              icon={Icon.ArrowUp}
              onAction={() => act(["side", target, "up"], `Moving ${monitor.name} up`)}
            />
            <Action
              title="Move Below"
              icon={Icon.ArrowDown}
              onAction={() => act(["side", target, "down"], `Moving ${monitor.name} down`)}
            />
            {!monitor.anchor && (
              <Action
                title="Make This the Anchor"
                icon={Icon.Anchor}
                onAction={() => act(["anchor", target], `Anchoring on ${monitor.name}`)}
              />
            )}
          </ActionPanel.Section>

          <ActionPanel.Section title="Zoom">
            <Action
              title="Zoom In"
              icon={Icon.PlusCircle}
              shortcut={{ modifiers: ["cmd"], key: "=" }}
              onAction={() => act(["zoom", target, "+0.25"], `Zooming ${monitor.name} in`)}
            />
            <Action
              title="Zoom Out"
              icon={Icon.MinusCircle}
              shortcut={{ modifiers: ["cmd"], key: "-" }}
              onAction={() => act(["zoom", target, "-0.25"], `Zooming ${monitor.name} out`)}
            />
            <ActionPanel.Submenu title="Set Zoom To…" icon={Icon.MagnifyingGlass}>
              {ZOOM_PRESETS.map((zoom) => (
                <Action
                  key={zoom}
                  title={describeZoom(zoom)}
                  onAction={() => act(["zoom", target, String(zoom)], `Zooming ${monitor.name}`)}
                />
              ))}
            </ActionPanel.Submenu>
          </ActionPanel.Section>

          <ActionPanel.Section title="Rotation">
            <ActionPanel.Submenu title="Rotate…" icon={Icon.RotateClockwise}>
              {ROTATIONS.map((rotation) => (
                <Action
                  key={rotation.value}
                  title={rotation.title}
                  onAction={() =>
                    act(["rotate", target, rotation.value], `Rotating ${monitor.name}`)
                  }
                />
              ))}
            </ActionPanel.Submenu>
          </ActionPanel.Section>

          <ActionPanel.Section>
            <Action
              title="Re-Apply Saved Layout"
              icon={Icon.ArrowClockwise}
              onAction={() => act(["apply"], "Applying the saved layout")}
            />
            <Action title="Refresh" icon={Icon.Repeat} onAction={() => refresh()} />
          </ActionPanel.Section>
        </ActionPanel>
      }
    />
  );
}
