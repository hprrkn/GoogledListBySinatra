@dir = "/home/prrknh/SinatraApp/GoogledListBySinatra"
worker_processes 2
working_directory @dir
timeout 30
listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 64
listen 8081, :tcp_nopuch => true
pid "#{@dir}/tmp/pids/unicorn.pid"
stderr_path "#{@dir}/log/unicorn.stderr.log"
stdout_path "#{@dir}/log/unicorn.stdout.log"
