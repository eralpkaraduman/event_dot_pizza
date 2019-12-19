import 'package:test/test.dart';
import 'package:event_dot_pizza/utils.dart';

void main() {
  test('parseRedirectParams', () {
    const url =
        'event.pizza://handle_meetup_redirect?access_token=TOKEN&token_type=bearer&expires_in=3600';
    Map params = parseRedirectParams(url);
    expect(params['access_token'], 'TOKEN');
    expect(params['token_type'], 'bearer');
    expect(params['expires_in'], '3600');
  });
}
