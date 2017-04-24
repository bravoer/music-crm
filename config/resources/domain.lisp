(in-package :mu-cl-resources)

(defparameter *supply-cache-headers-p* t
  "when non-nil, cache headers are supplied.  this works together with mu-cache.")
(setf *cache-model-properties-p* t)


;;;; define the resource

(define-resource score ()
  :class (s-prefix "music:Score")
  :properties `((:title :string ,(s-prefix "nie:title"))
                (:comment :string ,(s-prefix "nie:description"))
                (:composer :string ,(s-prefix "music:composer"))
                (:arranger :string ,(s-prefix "music:arranger"))
                (:duration :string ,(s-prefix "dcterms:extent"))
                (:genre :string ,(s-prefix "music:genre"))
                (:publisher :string ,(s-prefix "nco:publisher"))
                (:status :string ,(s-prefix "bravoer:status"))
                (:location :string ,(s-prefix "bravoer:libraryLocation"))
                (:is-original :boolean ,(s-prefix "music:isOriginalScore"))
                (:loan :string ,(s-prefix "music:loan"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/scores/")
  :has-many `((part :via ,(s-prefix "nie:isLogicalPartOf")
			   :inverse t
			   :as "parts"))
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "scores")

(define-resource part ()
  :class (s-prefix "music:Part")
  :properties `((:instrument :string ,(s-prefix "music:instrument"))
                (:instrument-part :string ,(s-prefix "music:instrumentPart"))
                (:key :string ,(s-prefix "music:key"))
                (:clef :string ,(s-prefix "music:clef"))
                (:file :string ,(s-prefix "nfo:fileUrl"))
		(:name :string ,(s-prefix "nie:title"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/parts/")
  :has-one `((score :via ,(s-prefix "nie:isLogicalPartOf")
                            :as "score"))
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "parts")

(define-resource musician ()
  :class (s-prefix "bravoer:Musician")
  :properties `((:prefix :string ,(s-prefix "vcard:hasHonorificPrefix"))
		(:first-name :string ,(s-prefix "vcard:hasGivenName"))
		(:last-name :string ,(s-prefix "vcard:hasFamilyName"))
		(:instrument :string ,(s-prefix "music:instrument"))
		(:email :url ,(s-prefix "vcard:hasEmail"))
		(:birthdate :date ,(s-prefix "vcard:bday"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/contacts/")
  :has-one `((address :via ,(s-prefix "locn:address")
		      :as "address")
	     (user :via ,(s-prefix "bravoer:hasUser")
		      :as "user"))
  :has-many `((musician-group :via ,(s-prefix "vcard:hasMember")
                         :inverse t
			 :as "groups")
              (telephone :via ,(s-prefix "vcard:hasTelephone")
			 :as "telephones")
              (event :via ,(s-prefix "bravoer:attendee")
		     :inverse t
		     :as "attendances")
	      (event :via ,(s-prefix "bravoer:legitimateAbsentee")
		     :inverse t
		     :as "legitimate-absences")
	      (event :via ,(s-prefix "bravoer:illegitimateAbsentee")
		     :inverse t
		     :as "illegitimate-absences"))
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "musicians")

(define-resource sympathizer ()
  :class (s-prefix "bravoer:Sympathizer")
  :properties `((:prefix :string ,(s-prefix "vcard:hasHonorificPrefix"))
		(:first-name :string ,(s-prefix "vcard:hasGivenName"))
		(:last-name :string ,(s-prefix "vcard:hasFamilyName"))
		(:organization-name :string ,(s-prefix "vcard:hasOrganizationName"))
                (:communication :string ,(s-prefix "bravoer:communicationsMedium"))
		(:email :url ,(s-prefix "vcard:hasEmail"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/contacts/")
  :has-one `((address :via ,(s-prefix "locn:address")
		      :as "address"))
  :has-many `((telephone :via ,(s-prefix "vcard:hasTelephone")
                         :as "telephones")
              (sponsorship :via ,(s-prefix "bravoer:sponsor")
		     :inverse t
		     :as "sponsorships")
              (event :via ,(s-prefix "bravoer:helper")
		     :inverse t
		     :as "voluntary-activities"))
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "sympathizers")

(define-resource address ()
  :class (s-prefix "locn:Address")
  :properties `((:street :string ,(s-prefix "locn:thoroughfare"))
		(:number :string ,(s-prefix "locn:poBox"))
		(:post-code :string ,(s-prefix "locn:postCode"))
		(:city :string ,(s-prefix "locn:postName")))
  :resource-base (s-url "http://data.bravoer.be/id/addresses/")
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "addresses")

(define-resource telephone ()
  :class (s-prefix "vcard:Voice")
  :properties `((:value :url,(s-prefix "rdf:value")))
  :resource-base (s-url "http://data.bravoer.be/id/telephones/")
  :authorization (list :show (s-prefix "authToken:show")
                       :update (s-prefix "authToken:update")
                       :create (s-prefix "authToken:create")
                       :delete (s-prefix "authToken:delete"))
  :on-path "telephones")

(define-resource event ()
  :class (s-prefix "schema:Event")
  :properties `((:name :string,(s-prefix "schema:name"))
		(:type :url,(s-prefix "schema:additionalType"))
		(:start-date :date ,(s-prefix "schema:startDate"))
		(:end-date :date ,(s-prefix "schema:endDate"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/events/")
  :has-many `((musician :via ,(s-prefix "bravoer:attendee")
			:as "attendees")
	      (musician :via ,(s-prefix "bravoer:legitimateAbsentee")
			:as "legitimate-absentees")
	      (musician :via ,(s-prefix "bravoer:illegitimateAbsentee")
			:as "illegitimate-absentees")
              (sponsorship :via ,(s-prefix "bravoer:sponsored")
		     :inverse t
		     :as "sponsorships")
              (sympathizer :via ,(s-prefix "bravoer:helper")
			:as "helpers"))
  :authorization (list :show (s-prefix "authToken:show")
                        :update (s-prefix "authToken:update")
                        :create (s-prefix "authToken:create")
                        :delete (s-prefix "authToken:delete"))
  :on-path "events")

(define-resource musician-group ()
  :class (s-prefix "bravoer:MusicianGroup")
  :properties `((:name :string,(s-prefix "vcard:hasName"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/musician-groups/")
  :has-many `((musician :via ,(s-prefix "vcard:hasMember")
			:as "members"))
  :authorization (list :show (s-prefix "authToken:show")
                        :update (s-prefix "authToken:update")
                        :create (s-prefix "authToken:create")
                        :delete (s-prefix "authToken:delete"))
  :on-path "musician-groups")

(define-resource sponsorship ()
  :class (s-prefix "bravoer:Sponsorship")
  :properties `((:amount :double ,(s-prefix "schema:amount"))
		(:created :date ,(s-prefix "dcterms:created"))
		(:modified :date ,(s-prefix "dcterms:modified")))
  :resource-base (s-url "http://data.bravoer.be/id/sponsorships/")
  :has-one `((event :via ,(s-prefix "bravoer:sponsored")
		     :as "event")
              (sympathizer :via ,(s-prefix "bravoer:sponsor")
			:as "sponsor"))
  :authorization (list :show (s-prefix "authToken:show")
                        :update (s-prefix "authToken:update")
                        :create (s-prefix "authToken:create")
                        :delete (s-prefix "authToken:delete"))
  :on-path "sponsorships")

(define-resource user ()
  :class (s-prefix "foaf:Person")
  :resource-base (s-url "http://data.bravoer.be/id/users/")
  :properties `((:name :string ,(s-prefix "foaf:name")))
  :on-path "users")
