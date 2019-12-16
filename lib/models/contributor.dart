class Contributor {
  String login, htmlUrl, avatarUrl;
  Contributor({
    this.login,
    this.htmlUrl,
    this.avatarUrl,
  });
  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      login: json['login'],
      htmlUrl: json['html_url'],
      avatarUrl: json['avatar_url'],
    );
  }
}
