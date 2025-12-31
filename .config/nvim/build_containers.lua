return {
  default_engine = "docker",
  user = "0",
  bd_alias = "make -j 12&&make install&&ldconfig",
  projects = {
        ["/home/agrses/Development/"] = {
            run_all = true,
            user = "0",
            containers = {
                { name = "proj", workdir = "/home/dev/build", label = "proj" },
            },
        },
    },
}
