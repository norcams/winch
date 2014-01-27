#!/bin/bash -vx
quantum router-create testrouter
quantum router-gateway-set testrouter floatingnet
quantum router-interface-add testrouter testsubnet
