{ config, lib, inputs, pkgs, ... }:

let
  mapAttrsAndKeys = callback: list:
    (lib.foldl' (acc: value: acc // (callback value)) { } list);

  cfg = config.hardware.monitors;
  pwas = config.applications.firefox.pwas.sites;
  hycov = inputs.hycov.packages.${pkgs.system}.hycov;
  deckRotation = if (config.applications.steam.session.steamdeck) then
    ",transform,3"
  else
    "";
in {
  home-manager.users = let
    users = lib.filter (user: config.system.user.${user}.enable == true)
      (lib.attrNames config.system.user);
  in mapAttrsAndKeys (user:
    let
      username = config.system.user.${user}.username;
      singleMonWRules = if (user != "work") then ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(startup-nvchad)$
        windowrulev2 = workspace 3 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 4 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 4 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
        windowrulev2 = workspace 5 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 6 silent, class:^(io.missioncenter.MissionCenter)$ # Task Manager
        windowrulev2 = workspace 7 silent, class:^(startup-kitty)$ # Terminal
      '' else ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(startup-nvchad)$
        windowrulev2 = workspace 3 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 4 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 5 silent, class:^(io.missioncenter.MissionCenter)$ # Task Manager
        windowrulev2 = workspace 6 silent, class:^(startup-kitty)$ # Terminal
      '';

      dualMonWRules = ''
        windowrulev2 = workspace 1 silent, class:^(firefox)$
        windowrulev2 = workspace 2 silent, class:^(startup-nvchad)$
        windowrulev2 = workspace 3 silent, class:^(Steam|steam|steam_app_.*)$, title:^((?!notificationtoasts.*).)*$
        windowrulev2 = workspace 3 silent, title:^(.*Steam[A-Za-z0-9\s]*)$
        windowrulev2 = workspace 11 silent, class:^(WebCord|Signal|pwas)$
        windowrulev2 = workspace 12 silent, class:^(org\.gnome\.Nautilus)$
        windowrulev2 = workspace 13 silent, class:^(io.missioncenter.MissionCenter)$ # Task manager
        windowrulev2 = workspace 14 silent, class:^(startup-kitty)$ # Terminal
      '';

      finalWRules = if (cfg.main.enable && cfg.secondary.enable) then
        dualMonWRules
      else
        singleMonWRules;
    in {
      ${username}.home.file.".config/hypr/hyprland.conf".text = ''
        # See available monitors with 'hyprctl monitors'
        monitor = ${cfg.main.name},${cfg.main.resolution}@${cfg.main.refreshRate},${cfg.main.position},${cfg.main.scaling}${deckRotation}
        workspace = 1, monitor:${cfg.main.name}, default:true
        workspace = 2, monitor:${cfg.main.name}
        workspace = 3, monitor:${cfg.main.name}
        workspace = 4, monitor:${cfg.main.name}
        workspace = 5, monitor:${cfg.main.name}
        workspace = 6, monitor:${cfg.main.name}
        workspace = 7, monitor:${cfg.main.name}
        workspace = 8, monitor:${cfg.main.name}
        workspace = 9, monitor:${cfg.main.name}
        workspace = 10, monitor:${cfg.main.name}

        monitor = ${cfg.secondary.name},${cfg.secondary.resolution}@${cfg.secondary.refreshRate},${cfg.secondary.position},${cfg.secondary.scaling}
        workspace = 11, monitor:${cfg.secondary.name}, default:true
        workspace = 12, monitor:${cfg.secondary.name}
        workspace = 13, monitor:${cfg.secondary.name}
        workspace = 14, monitor:${cfg.secondary.name}
        workspace = 15, monitor:${cfg.secondary.name}
        workspace = 16, monitor:${cfg.secondary.name}
        workspace = 17, monitor:${cfg.secondary.name}
        workspace = 18, monitor:${cfg.secondary.name}
        workspace = 19, monitor:${cfg.secondary.name}
        workspace = 20, monitor:${cfg.secondary.name}

        env = WLR_DRM_NO_ATOMIC,1

        general {
          border_size = 1
          no_border_on_floating = false
          gaps_in = 0
          gaps_out = 0
          col.inactive_border = rgb(000000)
          col.active_border = rgb(505050)
          layout = dwindle
          resize_on_border = true
          allow_tearing = true
        }

        decoration {
          rounding = 5
          drop_shadow = false
        }

        animations {
          enabled = yes
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
        }

        input {
          kb_layout = us,gr
          kb_options = grp:win_space_toggle # Change input language with Win + Space
          follow_mouse = 2 # Focus mouse on other windows on hover but not the keyboard
          force_no_accel = true
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          vrr = 2
        }

        dwindle {
          pseudotile = yes
          preserve_split = yes
        }

        master {
          new_is_master = true
        }

        xwayland {
          use_nearest_neighbor = false
        }

        # Set mod key to Super
        $mainMod = SUPER

        #Desktop usage
        bind = $mainMod, R, exec, rofi -show drun
        bind = $mainMod, V, exec, clipman pick -t rofi
        bind = , Print, exec, grimblast copy output
        bind = SHIFT, Print, exec, grimblast edit output
        bind = $mainMod, Print, exec, grimblast --freeze copy area
        bind = $mainMod SHIFT, Print, exec, grimblast --freeze edit area
        bind = ALT, Print, exec, grimblast copy
        bind = $mainMod ALT, Print, exec, grimblast edit
        bind = $mainMod, L, exec, swaylock-wrapper lock force
        bind = $mainMod SHIFT, L, exec, wlogout
        bind = $mainMod, N, exec, swaync-client -t -sw
        bind = $mainMod SHIFT, N, exec, swaync-client -d -sw
        bind = $mainMod, C, exec, hyprpicker --autocopy
        bind = $mainMod SHIFT, P, exec, hyprfreeze -a

        # Window control
        bind = $mainMod, Q, killactive
        bind = $mainMod, T, togglefloating,
        bind = $mainMod, P, pseudo
        bind = $mainMod, S, togglesplit
        bind = $mainMod, F, fullscreen, 0
        bind = $mainMod, M, fullscreen, 1

        # Move focus with mod key + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Move position with mod key, shift + arrow keys
        bind = $mainMod SHIFT, left, movewindow, l
        bind = $mainMod SHIFT, right, movewindow, r
        bind = $mainMod SHIFT, up, movewindow, u
        bind = $mainMod SHIFT, down, movewindow, d

        # Switch workspaces with mod key + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10
        bind = $mainMod ALT, 1, workspace, 11
        bind = $mainMod ALT, 2, workspace, 12
        bind = $mainMod ALT, 3, workspace, 13
        bind = $mainMod ALT, 4, workspace, 14
        bind = $mainMod ALT, 5, workspace, 15
        bind = $mainMod ALT, 6, workspace, 16
        bind = $mainMod ALT, 7, workspace, 17
        bind = $mainMod ALT, 8, workspace, 18
        bind = $mainMod ALT, 9, workspace, 19
        bind = $mainMod ALT, 0, workspace, 20

        # Move active window to a workspace with mod key + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10
        bind = $mainMod SHIFT ALT, 1, movetoworkspace, 11
        bind = $mainMod SHIFT ALT, 2, movetoworkspace, 12
        bind = $mainMod SHIFT ALT, 3, movetoworkspace, 13
        bind = $mainMod SHIFT ALT, 4, movetoworkspace, 14
        bind = $mainMod SHIFT ALT, 5, movetoworkspace, 15
        bind = $mainMod SHIFT ALT, 6, movetoworkspace, 16
        bind = $mainMod SHIFT ALT, 7, movetoworkspace, 17
        bind = $mainMod SHIFT ALT, 8, movetoworkspace, 18
        bind = $mainMod SHIFT ALT, 9, movetoworkspace, 19
        bind = $mainMod SHIFT ALT, 0, movetoworkspace, 20

        # Scroll through existing workspaces with mod key + scroll
        bind = $mainMod, mouse_down, workspace, e-1
        bind = $mainMod, mouse_up, workspace, e+1

        # Move/resize windows with mod key + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # Move apps to workspaces
        ${finalWRules}

        # Hide maximized window borders
        windowrulev2 = noborder, fullscreen:1

        # Inhibit idle for apps
        windowrulev2 = idleinhibit focus, class:^(org\.gnome\.clocks|Steam|steam|steam_app_.*)$

        # Tile apps
        windowrulev2 = tile, class:^(Godot.*|Steam|steam_app_.*|photoshop\.exe|DesktopEditors)$
        windowrulev2 = tile, title:^(.*Steam[A-Za-z0-9\s]*)$

        # Float apps
        windowrulev2 = float, class:^(feh)$

        # Pin floating apps
        windowrulev2 = pin, class:^(feh)$

        # Hide apps
        windowrulev2 = float, title:^(Firefox — Sharing Indicator|Wine System Tray)$
        windowrulev2 = size 0 0, title:^(Firefox — Sharing Indicator|Wine System Tray)$

        # Remove initial focus from apps
        windowrulev2 = noinitialfocus, class:^(steam)$, title:^(notificationtoasts.*)$, floating:1

        # Basic functionalities
        exec-once = sleep 2 && waybar & sleep 2 && hyprctl reload & /etc/polkit-gnome & swaync & hyprpaper & /etc/kdeconnectd & hyprland-per-window-layout & swayidle-wrapper & swayosd
        # Tray applications
        exec-once = kdeconnect-indicator & clipman clear --all & wl-paste -t text --watch clipman store & nm-applet --indicator
        # Standard applications
        exec-once = firefox & nautilus -w & nautilus -w & firefox --no-remote -P PWAs --name pwas ${pwas} & steam
        # Terminals/Task managers/IDEs
        exec-once = kitty --class startup-nvchad tmux new -s nvchad nvim & kitty --class startup-kitty tmux new -s terminals \; split-window -v \; select-pane -U \; split-window -h \; select-pane -D & missioncenter


        plugin = ${hycov}/lib/libhycov.so

        plugin {
          hycov {
            alt_toggle_auto_next = 1
            auto_exit = 1
            auto_fullscreen = 1
            disable_spawn = 0
            disable_workspace_change = 0
            enable_alt_release_exit = 1
            enable_gesture = 0
            enable_hotarea = 1
            hotarea_size = 10
            move_focus_distance = 100
            only_active_monitor = 1
            only_active_workspace = 1
            overview_gappi = 10
            overview_gappo = 10
            swipe_fingers = 4
          }
        }

        bind = ALT, tab, hycov:toggleoverview
        bind = $mainMod, tab, hycov:toggleoverview, forceall
        bind = ALT, left, hycov:movefocus, l
        bind = ALT, right, hycov:movefocus, r
        bind = ALT, up, hycov:movefocus, u
        bind = ALT, down, hycov:movefocus, d
      '';
    }) users;
}