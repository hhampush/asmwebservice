int main()
{   
    int sockfd;
	struct sockaddr_in self;
	char buffer[MAX_BUF];
    sockfd = socket(AF_INET, SOCK_STREAM, 0);

	self.sin_family = AF_INET;
	self.sin_port = htons(MY_PORT);
	self.sin_addr.s_addr = INADDR_ANY;
    bind(sockfd, (struct sockaddr*)&self, sizeof(self));

	listen(sockfd, 20);

	while (1)
	{	
        int clientfd;
		clientfd = accept(sockfd, NULL, NULL);
		send(clientfd, buffer, recv(clientfd, buffer, MAX_BUF, 0), 0);
		close(clientfd);
	}
	close(sockfd);
	return 0;
}