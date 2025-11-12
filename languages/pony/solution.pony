use "files"

actor Main
  new create(env: Env) =>
    try
      let input_file = env.args(1)?
      let part = env.args(2)?

      let file_auth = FileAuth(env.root)
      let path = FilePath(file_auth, input_file)
      match OpenFile(path)
      | let file: File =>
        var line_count: USize = 0
        for _ in file.lines() do
          line_count = line_count + 1
        end
        file.dispose()

        env.out.print(
          "Received " + line_count.string() +
          " lines of input for part " + part
        )
      end
    end
