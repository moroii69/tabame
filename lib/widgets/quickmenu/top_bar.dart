import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/classes/boxes.dart';
import '../../models/globals.dart';
import '../../models/settings.dart';
import '../../models/win32/win32.dart';
import '../itzy/quickmenu/button_always_awake.dart';
import '../itzy/quickmenu/button_audio.dart';
import '../itzy/quickmenu/button_bookmarks.dart';
import '../itzy/quickmenu/button_case_change.dart';
import '../itzy/quickmenu/button_change_theme.dart';
import '../itzy/quickmenu/button_changelog.dart';
import '../itzy/quickmenu/button_chars.dart';
import '../itzy/quickmenu/button_closeonfocus.dart';
import '../itzy/quickmenu/button_countdown.dart';
import '../itzy/quickmenu/button_fancyshot.dart';
import '../itzy/quickmenu/button_hide_desktop_files.dart';
import '../itzy/quickmenu/button_logo_drag.dart';
import '../itzy/quickmenu/button_media_control.dart';
import '../itzy/quickmenu/button_mic_mute.dart';
import '../itzy/quickmenu/button_open_settings.dart';
import '../itzy/quickmenu/button_persistent_reminders.dart';
import '../itzy/quickmenu/button_pin_window.dart';
import '../itzy/quickmenu/button_quickactions_menu.dart';
import '../itzy/quickmenu/button_shutdown.dart';
import '../itzy/quickmenu/button_spotify.dart';
import '../itzy/quickmenu/button_task_manager.dart';
import '../itzy/quickmenu/button_timers.dart';
import '../itzy/quickmenu/button_toggle_desktop.dart';
import '../itzy/quickmenu/button_toggle_hidden_files.dart';
import '../itzy/quickmenu/button_workspace.dart';
import '../itzy/quickmenu/list_pinned_apps.dart';
import '../containers/bar_with_buttons.dart';
import '../itzy/quickmenu/button_toggle_taskbar.dart';
import '../itzy/quickmenu/button_virtual_desktop.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with QuickMenuTriggers {
  @override
  void initState() {
    super.initState();
    QuickMenuFunctions.addListener(this);
  }

  @override
  void refreshQuickMenu() {
    if (mounted) {
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Debug.add("QuickMenu: Topbar");
    Map<String, Widget> widgets = <String, Widget>{
      "TaskManagerButton": const TaskManagerButton(),
      "SpotifyButton": const SpotifyButton(),
      "WorkSpaceButton": const WorkSpaceButton(),
      "VirtualDesktopButton": const VirtualDesktopButton(),
      "ToggleTaskbarButton": const ToggleTaskbarButton(),
      "PinWindowButton": const PinWindowButton(),
      "MicMuteButton": const MicMuteButton(),
      "AlwaysAwakeButton": const AlwaysAwakeButton(),
      "ChangeThemeButton": const ChangeThemeButton(),
      "HideDesktopFilesButton": const HideDesktopFilesButton(),
      "ToggleHiddenFilesButton": const ToggleHiddenFilesButton(),
      "QuickActionsMenuButton": const QuickActionsMenuButton(),
      "FancyShotButton": const FancyShotButton(),
      "TimersButton": const TimersButton(),
      "CountdownButton": const CountdownButton(),
      "BookmarksButton": const BookmarksButton(),
      "CustomCharsButton": const CustomCharsButton(),
      "ShutDownButton": const ShutDownButton(),
      "CaseChangeButton": const CaseChangeButton(),
      "CloseOnFocusLossButton": const CloseOnFocusLossButton(),
    };
    List<Widget> showWidgets = <Widget>[];
    final List<String> showWidgetsNames = Boxes().topBarWidgets;
    for (String x in showWidgetsNames) {
      if (x == "Deactivated:") break;
      if (widgets.containsKey(x)) {
        showWidgets.add(widgets[x]!);
      }
    }
    Globals.heights.topbar = 20;
    int width = 20 * 2;
    if (kDebugMode) width += 20;
    if (globalSettings.lastChangelog != Globals.version) width += 20;
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(size: 16),
          hoverColor: Colors.grey.withAlpha(50),
          tooltipTheme: Theme.of(context).tooltipTheme.copyWith(decoration: BoxDecoration(color: Theme.of(context).backgroundColor), preferBelow: false)),
      child: IconTheme(
        data: IconThemeData(
          size: 16,
          color: Theme.of(context).iconTheme.color,
        ),
        child: Container(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      width: 70,
                      child: BarWithButtons(
                        withScroll: false,
                        children: <Widget>[
                          SizedBox(width: 4),
                          LogoDragButton(),
                          AudioButton(),
                          MediaControlButton(),
                        ],
                      ),
                    ),
                    if (showWidgets.isNotEmpty)
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 10, maxWidth: 200),
                          child: BarWithButtons(
                            children: <Widget>[
                              if (globalSettings.persistentReminders.isNotEmpty) const PersistentRemindersWidget(),
                              ...List<Widget>.generate(showWidgets.length, (int i) {
                                Debug.add(
                                    "QuickMenu: Topbar: ${widgets.entries.firstWhere((MapEntry<String, Widget> element) => element.value == showWidgets[i], orElse: () => MapEntry<String, Widget>("Null", Container())).key}");
                                return showWidgets[i];
                              })
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 2),
                    if (!globalSettings.quickMenuPinnedWithTrayAtBottom)
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 10, maxWidth: 200),
                          child: const PinnedApps(),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: width + 5,
                child: Align(
                  child: BarWithButtons(
                    height: 25,
                    withScroll: false,
                    children: <Widget>[
                      if (kDebugMode)
                        Align(
                          child: Tooltip(
                            message: "Testing",
                            child: InkWell(
                              onTap: () async {
                                //
                                // QuickMenuFunctions.toggleQuickMenu(type: 3);
                                await WinUtils.screenCapture();
                              },
                              child: const Icon(Icons.textsms_outlined),
                            ),
                          ),
                        ),
                      const ToggleDesktopButton(),
                      if (globalSettings.lastChangelog != Globals.version) const CheckChangelogButton(),
                      const OpenSettingsButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
