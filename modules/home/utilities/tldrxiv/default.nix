{ config, lib, pkgs, ... }:
let
  cfg = config.pantry.home.utilities.tldrxiv;

  inherit (pkgs.python3Packages) buildPythonApplication fetchPypi hatchling;

  tldrxiv = buildPythonApplication rec {
    pname = "tldrxiv";
    version = "0.1.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-fmjAtQZVaQ6GJLbKnlcMKFiwnu15c0xkjVNYaga3iGQ=";
    };

    build-system = [ hatchling ];
    pythonImportsCheck = [ "tldrxiv" ];
    doCheck = false;

    meta = {
      description = "Generate digests for daily arXiv feeds";
      homepage = "https://github.com/PanosEconomou/tldrxiv";
      license = lib.licenses.mit;
      mainProgram = "tldrxiv";
    };
  };

  keyHook = ''
    TLDRXIV_LLM_KEY="$(${cfg.apiKeyCommand})" || {
      echo "tldrxiv: could not retrieve API Key" >&2
      exit 1
    }
    export TLDRXIV_LLM_KEY
  '';

  wrapped = pkgs.symlinkJoin {
    name = "tldrxiv-with-key";
    paths = [ tldrxiv ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/tldrxiv --run ${lib.escapeShellArg keyHook}
    '';
    meta.mainProgram = "tldrxiv";
  };
in
{
  options.pantry.home.utilities.tldrxiv = {
    enable = lib.mkEnableOption "enable tldrxiv";

    apiKeyCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "pass show llm/gemini";
      example = "pass show llm/gemini";
      description = ''
        Shell command whose stdout is exported as {env}`TLDRXIV_LLM_KEY` for the duration of each invocation. The command itself is stored in the Nix store; its output never is. Leave null to manage the key yourself.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (if cfg.apiKeyCommand == null then tldrxiv else wrapped) ];
  };
}
