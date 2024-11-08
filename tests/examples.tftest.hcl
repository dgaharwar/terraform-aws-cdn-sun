
run "basic" {
  module {
    source = "./examples/basic"
  }
}
run "custom-origin" {
  module {
    source = "./examples/custom-origin"
  }
}
run "s3-origin" {
  module {
    source = "./examples/s3-origin"
  }
}