using MariaDB

for testfile in [
        "test_funcs.jl"
    ]
    include(testfile)
end
