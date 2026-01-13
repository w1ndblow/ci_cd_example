import pytest

@pytest.mark.usefixtures('host')
def test_smoke_provisioner(host):
    for service in ["actions.runner.w1ndblow-ci_cd_example.vkcs.service",
                    "docker.service"]:
        svc = host.service("actions.runner.w1ndblow-ci_cd_example.vkcs.service")
        assert svc.is_running
        assert svc.is_enabled
