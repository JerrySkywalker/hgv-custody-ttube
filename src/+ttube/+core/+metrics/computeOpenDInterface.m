function artifact = computeOpenDInterface(varargin)
%COMPUTEOPENDINTERFACE Return an OpenD interface artifact.

artifact = struct();
artifact.schema_version = 'opend_interface.v0';
artifact.metric_family = 'OpenD';
artifact.source_stage_family = 'Stage14';
artifact.production_aligned = false;
artifact.status = 'interface_ready_not_stage05_production_aligned';
artifact.notes = ['OpenD is treated as a Stage14 RAAN/phase/orientation ' ...
    'artifact family. This sprint does not run Stage14 scans.'];
end
