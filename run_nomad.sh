pushd $HOME/seminar/nomad/docker-nomad
docker-compose up -d
popd
sleep 1
pushd $HOME/seminar/nomad/nomad-autoscaler-demos/vagrant/horizontal-app-scaling/jobs
echo "Deploying traefik ..."
nomad job run traefik.nomad
nomad job status traefik
TRAEFIK_ALLOC_ID=$(nomad alloc status -t '{{ range . }}{{if eq .JobID "traefik"}}{{if eq .DesiredStatus "run"}}{{ .ID }}{{end}}{{end}}{{end}}')
nomad alloc status ${TRAEFIK_ALLOC_ID}
echo "Deploying prometheus ..."
nomad job run prometheus.nomad
echo "Deploying Loki..."
nomad job run loki.nomad
echo "Deploying Grafana..."
nomad job run grafana.nomad
echo "Deploying autoscaler..."
nomad job run autoscaler.nomad
AUTOSCALER_ALLOC_ID=$(nomad alloc status -t '{{ range . }}{{if eq .JobID "autoscaler"}}{{if eq .DesiredStatus "run"}}{{ .ID }}{{end}}{{end}}{{end}}')
nomad alloc logs -stderr ${AUTOSCALER_ALLOC_ID} autoscaler
echo "Deploying webapp..."
nomad job run webapp.nomad
nomad alloc logs -stderr ${AUTOSCALER_ALLOC_ID} autoscaler
popd
