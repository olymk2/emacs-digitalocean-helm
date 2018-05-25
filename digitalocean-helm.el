;;; digitalocean-helm.el --- Create and manipulate digitalocean droplets -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Oliver Marks

;; Author: Oliver Marks <oly@digitaloctave.com>
;; URL: https://github.com/olymk2/digitalocean-api
;; Keywords: Processes tools
;; Version: 0.1
;; Created 01 July 2018
;; Package-Requires: ((emacs "24.3")(helm "2.5"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implid warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This provides a set of magit style popups for interacting with your containers.
;; It wraps docker and docker-compose commands and allows you to select containers and toggle
;; the various paramters passed to the commands.

;; It can be extended to run tests inside containers and comes with some predefined setups, it
;; should also be easy to add in your own common commands to the interactive popups

;;; Code:

(defvar helm-digitalocean-droplet-source
  ;; Helm droplet list and actions
  '((name . "Digitalocean Droplets")
    (candidates . do/digitalocean-droplet-list)
    (action . (("Open Shell" .
		(lambda (candidate)
		  (do/launch-shell
		   (do/get-droplet-name-from-candidate candidate)
                   (do/build-ssh-path candidate "~/"))))
	       ("Snapshot" .
		(lambda (candidate)
		  (do/exec-droplet-action
		   (do/get-droplet-id-from-candidate candidate)
                   "snapshot")))
	       ("Power Off" .
		(lambda (candidate)
		  (do/exec-droplet-action
		   (do/get-droplet-id-from-candidate candidate)
                   "power_off")))
	       ("Power On" .
		(lambda (candidate)
		  (do/exec-droplet-action
		   (do/get-droplet-id-from-candidate candidate)
                   "power_on")))
	       ("Restart" .
		(lambda (candidate)
		  (do/exec-droplet-action
		   (do/get-droplet-id-from-candidate candidate)
                   "restart")))
	       ("Destroy" .
		(lambda (candidate)
		  (do/exec-droplet-action
		   (do/get-droplet-id-from-candidate candidate)
                   "destroy")))))))

(defun do/helm-digitalocean-droplets ()
  ;; Show helm droplet list
  (interactive)
  (helm :sources '(helm-digitalocean-droplet-source)))


(defvar helm-digitalocean-image-source
  ;; Helm image list and actions
  '((name . "Digitalocean Images")
    (candidates . do/digitalocean-images-list)
    (action . (("Test" . (lambda (candidate)
			   (message-box
			    "selected: %s"
			    (helm-marked-candidates))))))))

(defun do/helm-digitalocean-images ()
  ;; Show helm image list
  (interactive)
  (helm :sources '(helm-digitalocean-image-source)))

(defvar helm-digitalocean-region-source
  ;; Helm region list and actioons
  '((name . "Digitalocean Regions")
    (candidates . do/digitalocean-regions-list)
    (action . (("Test" . (lambda (candidate)
			   (message-box
			    "selected: %s"
			    (helm-marked-candidates))))))))

(defun do/helm-digitalocean-regions ()
  ;; Show helm region list
  (interactive)
  (helm :sources '(helm-digitalocean-region-source)))

(defun do/get-droplet-id-from-candidate (candidate)
  ;; Give a helm droplet candidate get the droplets id
  (number-to-string (cdr (assoc 'id candidate))))

(defun do/get-droplet-name-from-candidate (candidate)
  ;; Give a helm droplet candidate get the droplets name
  (cdr (assoc 'name candidate)))

;;; (Features)
(provide 'digitalocean-helm)
;;; digitalocean-helm.el ends here
