package Pastebeest::Command::migrate;
use Mojo::Base 'Mojolicious::Command';
use Mojo::File;

use Getopt::Long;

has description => 'Run migrations';
has usage       => "Usage: APPLICATION migrate [MIGRATION]\n";

sub run {
    my ( $self, @args ) = @_;

    my $home = Mojo::Home->new;
    $home->detect;

    my $refresh = '';  
    my $migration = '';

    GetOptions( 'refresh' => \$refresh, 'migration=s' => \$migration );

    # say $migration;
    # say $refresh;

    my $migrations = Mojo::Pg::Migrations->new(pg => $self->app->pg);
    my $migrationsDirectory = $home->child('database');
    opendir(my $dh, $migrationsDirectory) || die "Can't open $migrationsDirectory!";
    my $migrationData = "";
    if($migration) {
        say "Load migrations from $migration";
        my $file = Mojo::File->new("$migrationsDirectory/$migration");
        $migrationData = $migrationData . "\n" . $file->slurp;
    } else {
        while (readdir $dh) {
            if($_ =~ /sql$/) {
                say "Load migrations from $_";
                my $file = Mojo::File->new("$migrationsDirectory/$_");
                $migrationData = $migrationData . "\n" . $file->slurp;
            }
        }
        closedir $dh;
    }
    
    
    my $migrator = $migrations->from_string($migrationData);

    if($refresh) {
        say "Refreshing migrations";
        $migrator->migrate(0);
    }
    say "Migrating to latest";
    $migrator->migrate;
}

1;
