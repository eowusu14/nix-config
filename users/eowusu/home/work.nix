{ config, lib, ... }:
{
  programs.git.settings.user.email = "owusu.boateng@flyzipline.com";

  programs.zsh = {
    shellAliases = {
      k = "kubectl";
      kdata = "kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-data";
      kpre = "kubectl config use-context arn:aws:eks:us-west-2:676657780981:cluster/primary-preprod";
      kstage = "kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-staging";
      kprod = "kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-production";
      awspre = "export AWS_PROFILE=preprod";
      awsprod = "export AWS_PROFILE=prod";
      awsdata = "export AWS_PROFILE=data";
      awslogin = "aws sso login";
      h = "herdr";
    };

    initContent = lib.mkOrder 680 ''
      [[ ! -f "${config.home.homeDirectory}/.config/zipline/env" ]] \
        || source "${config.home.homeDirectory}/.config/zipline/env"
    '';
  };
}
