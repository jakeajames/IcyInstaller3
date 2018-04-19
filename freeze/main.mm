#include <spawn.h>
#include <signal.h>

int main(int argc, char **argv, char **envp) {
	setuid(0);
				pid_t pid;
        int status;
				const char *path[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", NULL};
        posix_spawn(&pid, "/usr/bin/dpkg", NULL, NULL, (char**)argv, (char**)path);
        waitpid(pid, &status, 0);
				return 0;
}
