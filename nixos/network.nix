{
  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      ethernet.macAddress = "random";
      connectionConfig = {
        "ipv6.ip6-privacy" = 2;
      };
    };
  };
}
