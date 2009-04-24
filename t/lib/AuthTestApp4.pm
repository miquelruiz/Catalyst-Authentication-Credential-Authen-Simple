package AuthTestApp4;

use TestLogger;
use Catalyst qw/Authentication/;

use Test::More;
use Test::Exception;

sub authed_ok : Local {
	my ( $self, $c ) = @_;

        my $authd = $c->authenticate( { "username" => $c->request->param('username'),
	                               "password" => $c->request->param('password') });

	if ($authd){
	    $c->response->body( "authed " . $c->user->get('name') );
	} else {
            $c->response->body( "not authed" );
	}

        $c->logout;
}


__PACKAGE__->config->{'Plugin::Authentication'} = {
  'realms' => {
    'default' => {
      'store' => {
        'class' => 'Minimal',
        'users' => {
          bob => { name => "Bob Smith" },
          john => { name => "John Smith" }
	}
      },
      'credential' => {
        'class' => 'Authen::Simple',
        'authen' => [
          {
            'class' => 'Logger'
          },
        ],
      }
    }
  }
};

__PACKAGE__->log( TestLogger->new );

__PACKAGE__->setup();
