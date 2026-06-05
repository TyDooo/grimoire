{
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "127.0.0.0/8" # localhost
      "100.99.0.0/16" # netbird
      "10.0.0.0/8" # local network
    ];

  };
}
