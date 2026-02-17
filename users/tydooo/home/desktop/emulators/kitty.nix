{
  programs.kitty = {
    enable = true;
    environment.FZF_PREVIEW_IMAGE_HANDLER = "kitty";
    settings = {
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      dynamic_background_opacity = "yes";
      background_blur = 200;
    };
  };
}
