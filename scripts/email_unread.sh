#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh


email_unread_count()
{
  # Note the -n in curl line refers to ~/.netrc file containing email login creds.
  # For formatting/details see:
  # https://www.gnu.org/software/inetutils/manual/html_node/The-_002enetrc-file.html
  UNSEEN=$(curl -s -m ${server_timeout} -n imaps://${imap_server} -X 'STATUS INBOX (UNSEEN)')
  UNSEEN=${UNSEEN#*'UNSEEN'}  # removes chars before unread count
  UNSEEN=${UNSEEN%')'*}       # removes chars after unread count
  echo ${UNSEEN}

}

main()
{
  imap_server=$(get_tmux_option "@dracula-email-imapserver" "")
  server_timeout=$(get_tmux_option "@dracula-email-timeout" "2")
  email_failure_label=$(get_tmux_option "@dracula-email-failure-label" "🚫")
  unread_true_label=$(get_tmux_option "@dracula-email-unread-label" "📬")
  unread_false_label=$(get_tmux_option "@dracula-email-nounread-label" "📪")
  email_unread=$(email_unread_count)

  if [ "$email_unread" -eq "$email_unread" ] 2>/dev/null  # test if var is a number
  then
    if (( $email_unread > 0 )); then
      echo "$unread_true_label $email_unread"
    else
      echo "$unread_false_label 0"
    fi
  else
    echo "$unread_false_label $email_failure_label"
  fi
}

#run main driver program
main

