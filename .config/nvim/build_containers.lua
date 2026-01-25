return {
  default_engine = "docker",
  user = "0",
  bd_alias = "make -j 12&&make install&&ldconfig",
  projects = {
        ["/home/agrses/Development/Research/dev-containers/chem-dev/Docker/Vols/chem/CHEM"] = {
            run_all = true,
            user = "0",
            containers = {
                { name = "chem", workdir = "/home/dev/CHEM/build", label = "chem" },
            },
        },
        ["/home/agrses/Development/Research/dev-containers/chem-dev/Docker/Vols/vusrp-node/UHD-AERPAW"] = {
            run_all = true,
            user = "0",
            containers = {
                { name = "bs-0", workdir = "/home/dev/UHD-AERPAW/host/build", label = "bs-0" },
                { name = "ue-0", workdir = "/home/dev/UHD-AERPAW/host/build", label = "ue-0" },
                { name = "bs-1", workdir = "/home/dev/UHD-AERPAW/host/build", label = "bs-1" },
                { name = "ue-1", workdir = "/home/dev/UHD-AERPAW/host/build", label = "ue-1" },
            },
        },
    },
}
