#

# quick and dirty to get started... sorry!
# assumes one input path to project view_by_pid

use strict;
use warnings;

my $project_path = shift or die "ERROR: please provide path to OTP WGS project folder\n";
chomp $project_path;

warn "Checking path \"$project_path\" ...\n";

my @pids = `ls $project_path`;
chomp @pids;

warn "Found ".scalar(@pids)." PIDs \n";

my %insertsize_hash;
my @pid_samples;

foreach my $pid (@pids){
  my @insertsize_files = `ls $project_path/$pid/*/paired/merged-alignment/qualitycontrol/merged/insertsize_distribution/*_insertsizes.txt`;
  chomp @insertsize_files;
  foreach my $insertsize_file (@insertsize_files) {
    $insertsize_file =~ m /$pid\/(.*?)\/paired/;
    my $sample = $1;
    warn "$pid :: $sample :: $insertsize_file\n";   
    open (my $fh, "<$insertsize_file") or die "ERROR: cannot open file: $insertsize_file\n";
    my $pid__sample = "$pid"."__"."$sample";
    push (@pid_samples,$pid__sample);
    while (<$fh>){
      chomp;
      if (m/^(.*?)\t(.*?)$/){
       $insertsize_hash{$1}{$pid__sample}=$2;
      }
    }
    close ($fh);
  }
}

print "insert_size";
foreach my $pid_sample (sort @pid_samples){
  print "\t$pid_sample";
}
print "\n";

foreach my $size (sort { $a <=> $b } keys %insertsize_hash){
  print $size; 
  foreach my $pid_sample (sort @pid_samples){
    my $count = 0;
    $count = $insertsize_hash{$size}{$pid_sample} if defined $insertsize_hash{$size}{$pid_sample};
    print "\t$count";
  }
  print "\n";
}
