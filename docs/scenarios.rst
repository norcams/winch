Deployment scenarios
====================

This will document what deployment scenarios we are working to support, sorted by complexity.

Vagrant: controller and compute
-------------------------------

This is the simplest deployment scenario that will allow an instance to boot. 

Vagrant: management, controller and compute
-------------------------------------------



Notes, to be documented:

Samme som over, men med Foreman (uten provisjonering)

Vagrant med PXE

- management-noden i Vagrant (PXE, TFTP)
- Bridge til eksternt nett

1. PXE-boote og installere management-noden eksternt
2. Videre derfra ... via puppetmaster

Oveordnet:
- Basert på Havana
- RDO skal virke først - så må vi prøve med RHOS

Ting vi ikke har prøvd:

- Ceilometer (måling), Horizion (dashboard), og standard Cinder+Swift
- Automatisering av storage?

https://github.com/norcams/winch/issues/milestones

Versjon 0.1.0 (academic)



Versjon 0.2.0 (binocular):

RDO virker først :-)

Flere roller: storage01, storage02
 - cinder, swift
 - Ceph/Gluster



Versjon 0.3.0 (cocoa):

Flere roller:
network01, network02
 - Men redundans?
 - Flere nettverksnoder




