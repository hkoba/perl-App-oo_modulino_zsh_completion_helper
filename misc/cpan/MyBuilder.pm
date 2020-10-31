package
  MyBuilder;
use strict;
use warnings;
use utf8;

use parent qw(Module::Build);

use Module::CPANfile;

use File::Basename;
use File::Spec;

sub new {
  _add_zsh_fpath(
    shift->SUPER::new(@_)
  );
}

sub _add_zsh_fpath {
  my ($self) = @_;
  my $elem = 'zsh_fpath';
  $self->add_build_element($elem);

  # XXX: Is this portable? only tested in Fedora...
  my $zsh_fpath = "share/zsh/site-functions";

  $self->install_base_relpaths($elem => $zsh_fpath);
  $self->prefix_relpaths($_ => $elem => $zsh_fpath) for qw(core vendor site);

  my $installdirs = $self->installdirs;
  if ($self->install_path($elem)) {
    # Use specified value in Build.PL invocation.
  }
  elsif ($installdirs eq 'core' or $installdirs eq 'vendor') {
    $self->install_path($elem => "/usr/$zsh_fpath");
  }
  elsif ($installdirs eq 'site') {
    $self->install_path($elem => "/usr/local/$zsh_fpath");
  }
  else {
    die "Unknown installdirs to derive zsh_fpath: $installdirs";
  }

  $self;
}

# sub _default_zsh_fpath {
#   local $ENV{FPATH};
#   chomp(my $fpath = qx(zsh -f -c 'print -l \$fpath'));
#   grep {
#     m{/site-functions\z}
#   } split "\n", $fpath;
# }

# Copied from my YATT::Lite distribution
sub my_cpanfile_specs {
  my ($pack) = @_;
  my $file = Module::CPANfile->load("cpanfile");
  my $prereq = $file->prereq_specs;
  my %args;
  %{$args{requires}} = lexpand($prereq->{runtime}{requires});
  foreach my $phase (qw/configure runtime build test/) {
    %{$args{$phase . "_requires"}} = lexpand($prereq->{$phase}{requires});
  }
  %{$args{recommends}} = (map {lexpand($prereq->{$_}{recommends})}
			  keys %$prereq);
  %args
}

sub lexpand {
  return unless defined $_[0];
  %{$_[0]};
}

1;
