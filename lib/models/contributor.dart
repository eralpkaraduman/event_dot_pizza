class Contributor {
  String login, htmlUrl, avatarUrl, type;
  Contributor({
    this.login,
    this.htmlUrl,
    this.avatarUrl,
    this.type,
  });
  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      login: json['login'],
      htmlUrl: json['html_url'],
      avatarUrl: json['avatar_url'],
      type: json['type'],
    );
  }
}
